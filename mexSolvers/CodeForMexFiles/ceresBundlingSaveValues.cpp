/*
* arrayProduct.cpp - example in MATLAB External Interfaces
*
* Multiplies an input scalar (multiplier)
* times a MxN matrix (inMatrix)
* and outputs a MxN matrix (outMatrix)
*
* Usage : from MATLAB
*         >> outMatrix = arrayProduct(multiplier, inMatrix)
*
* This is a C++ MEX-file for MATLAB.
* Copyright 2017 The MathWorks, Inc.
*
*/

#include "mex.hpp"
#include "mexAdapter.hpp"
#include "ceres/ceres.h"

using ceres::AutoDiffCostFunction;
using ceres::CostFunction;
using ceres::Problem;
using ceres::Solve;
using ceres::Solver;
using ceres::IterationCallback;
using ceres::IterationSummary;
using ceres::CallbackReturnType;
using ceres::SOLVER_CONTINUE;



class SaveValuesCallback : public IterationCallback {
public:
    std::vector<double>* costPerIteration;
    std::vector<double>* timePerIteration;


    SaveValuesCallback(std::vector<double>* costPerIteration, std::vector<double>* timePerIteration) {
        this->costPerIteration = costPerIteration;
        this->timePerIteration = timePerIteration;
    }


    ~SaveValuesCallback() {}

    CallbackReturnType operator()(const IterationSummary& summary) {
        std::vector<double> values;
        costPerIteration->push_back(2*summary.cost);
        timePerIteration->push_back(summary.iteration_time_in_seconds);

        return SOLVER_CONTINUE;
    }

private:
};


struct Residual {
    Residual(double dIn) {
        d = dIn;
    }

    template <typename T>
    bool operator()(const T* const r0, const T* const r1, const T* const r2, const T* const s0, const T* const s1, const T* const s2, T* residual) const {
        residual[0] = sqrt((r0[0]-s0[0])* (r0[0] - s0[0]) + (r1[0] - s1[0]) * (r1[0] - s1[0]) + (r2[0] - s2[0]) * (r2[0] - s2[0]))-d;
        return true;
    }

private:
    // Observations for a sample.
    double d;
};




void optBundling(std::vector<std::vector<double>>* recievers, std::vector<std::vector<double>>* senders, std::vector<std::vector<double>>* data, std::vector<double>* costPerIteration, std::vector<double>* timePerIteration) {
    Problem problem;
    
    // Set up the only cost function (also known as residual). This uses
    // auto-differentiation to obtain the derivative (jacobian).
    for (int sender = 0; sender < data[0].size(); sender++) {
        std::vector<double> dataPoint = data[0][sender];
        for (int reciever = 0; reciever < dataPoint.size(); reciever++) {
            problem.AddResidualBlock(
                new AutoDiffCostFunction<Residual, 1, 1, 1, 1, 1, 1, 1>(
                    new Residual(dataPoint[reciever])),
                nullptr,
                &recievers[0][reciever][0], &recievers[0][reciever][1], &recievers[0][reciever][2], &senders[0][sender][0], &senders[0][sender][1], &senders[0][sender][2]);
        }
    }

    // Run the solver!
    Solver::Options options;
    SaveValuesCallback saveValuesCallback = SaveValuesCallback(costPerIteration, timePerIteration);
    options.callbacks.push_back(&saveValuesCallback);

    options.max_num_iterations = 1000;
//     options.minimizer_progress_to_stdout = true;
    Solver::Summary summary;
    Solve(options, &problem, &summary);
//     std::cout << summary.BriefReport() << "\n";



}
class MexFunction : public matlab::mex::Function {

public:
    void operator()(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs) {
//         checkArguments(outputs, inputs);
        matlab::data::TypedArray<double> initialRin = std::move(inputs[0]);
        matlab::data::TypedArray<double> initialSin = std::move(inputs[1]);
        matlab::data::TypedArray<double> din = std::move(inputs[2]);
        std::vector<std::vector<double>> initialR;
        int i = 0;
        for(auto elem : initialRin){
            if(i%3==0){
                initialR.push_back(std::vector<double>());
            }
            initialR.back().push_back(elem);
            i++;
        }

        size_t nbrRecievers = initialR.size();

        std::vector<std::vector<double>> initialS;
        i = 0;
        for(auto elem : initialSin){
            if(i%3==0){
                initialS.push_back(std::vector<double>());
            }
            initialS.back().push_back(elem);
            i++;
        }
        size_t nbrSenders = initialS.size();


        std::vector<std::vector<double>> d;
        
        i = 0;
        for(auto elem : din){
            if(i%nbrRecievers==0){
                d.push_back(std::vector<double>());
            }
            d.back().push_back(elem);
            i++;
        }

        std::vector<double> costPerIteration;
        std::vector<double> timePerIteration;

        optBundling(&initialR, &initialS, &d, &costPerIteration, &timePerIteration);
        using namespace matlab::data;

        ArrayFactory factory;

        outputs[0] = factory.createArray<double>({ 3, nbrRecievers });
        for(int i = 0; i<nbrRecievers; i++){
            for(int j = 0; j<3; j++){
                outputs[0][j][i] = initialR[i][j];
            }
        }

        outputs[1] = factory.createArray<double>({ 3, nbrSenders });
        for(int i = 0; i<nbrSenders; i++){
            for(int j = 0; j<3; j++){
                outputs[1][j][i] = initialS[i][j];
            }
        }


        outputs[2] = factory.createArray<double>({1, costPerIteration.size()});
        for(size_t i = 0; i<costPerIteration.size(); i++){
            outputs[2][0][i] = costPerIteration[i];
        }

        outputs[3] = factory.createArray<double>({1, timePerIteration.size()});
        for(size_t i = 0; i<timePerIteration.size(); i++){
            outputs[3][0][i] = timePerIteration[i];
        }

    }

    void arrayProduct(matlab::data::TypedArray<double>& inMatrix, double multiplier) {
        
        for (auto& elem : inMatrix) {
            elem *= multiplier;
        }
    }

    void checkArguments(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs) {
        std::shared_ptr<matlab::engine::MATLABEngine> matlabPtr = getEngine();
        matlab::data::ArrayFactory factory;

        if (inputs.size() != 2) {
            matlabPtr->feval(u"error", 
                0, std::vector<matlab::data::Array>({ factory.createScalar("Two inputs required") }));
        }

        if (inputs[0].getNumberOfElements() != 1) {
            matlabPtr->feval(u"error", 
                0, std::vector<matlab::data::Array>({ factory.createScalar("Input multiplier must be a scalar") }));
        }
        
        if (inputs[0].getType() != matlab::data::ArrayType::DOUBLE ||
            inputs[0].getType() == matlab::data::ArrayType::COMPLEX_DOUBLE) {
            matlabPtr->feval(u"error", 
                0, std::vector<matlab::data::Array>({ factory.createScalar("Input multiplier must be a noncomplex scalar double") }));
        }

        if (inputs[1].getType() != matlab::data::ArrayType::DOUBLE ||
            inputs[1].getType() == matlab::data::ArrayType::COMPLEX_DOUBLE) {
            matlabPtr->feval(u"error", 
                0, std::vector<matlab::data::Array>({ factory.createScalar("Input matrix must be type double") }));
        }

        if (inputs[1].getDimensions().size() != 2) {
            matlabPtr->feval(u"error", 
                0, std::vector<matlab::data::Array>({ factory.createScalar("Input must be m-by-n dimension") }));
        }
    }
    

    

};