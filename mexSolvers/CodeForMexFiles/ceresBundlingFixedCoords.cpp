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

struct Residual3 {
    Residual3(double dIn) {
        d = dIn;
    }

    template <typename T>
    bool operator()(const T* const r0, const T* const r1, const T* const r2, const T* const s0, const T* const s1, const T* const s2, T* residual) const {
        residual[0] = sqrt((r0[0] - s0[0]) * (r0[0] - s0[0]) + (r1[0] - s1[0]) * (r1[0] - s1[0]) + (r2[0] - s2[0]) * (r2[0] - s2[0])) - d;
        return true;
    }

private:
    // Observations for a sample.
    double d;
};

struct Residual0 {
    Residual0(double dIn) {
        d = dIn;
    }

    template <typename T>
    bool operator()(const T* const s0, const T* const s1, const T* const s2, T* residual) const {
        residual[0] = sqrt(s0[0] * s0[0] + s1[0] * s1[0] + s2[0] * s2[0]) - d;
        return true;
    }

private:
    // Observations for a sample.
    double d;
};

struct Residual1 {
    Residual1(double dIn) {
        d = dIn;
    }

    template <typename T>
    bool operator()(const T* const r0, const T* const s0, const T* const s1, const T* const s2, T* residual) const {
        residual[0] = sqrt((r0[0] - s0[0]) * (r0[0] - s0[0]) + s1[0] * s1[0] + s2[0] * s2[0]) - d;
        return true;
    }

private:
    // Observations for a sample.
    double d;
};

struct Residual2 {
    Residual2(double dIn) {
        d = dIn;
    }

    template <typename T>
    bool operator()(const T* const r0, const T* const r1, const T* const s0, const T* const s1, const T* const s2, T* residual) const {
        residual[0] = sqrt((r0[0] - s0[0]) * (r0[0] - s0[0]) + (r1[0] - s1[0]) * (r1[0] - s1[0]) + s2[0] * s2[0]) - d;
        return true;
    }

private:
    // Observations for a sample.
    double d;
};




void optBundling(std::vector<double>* recievers, std::vector<std::vector<double>>* senders, std::vector<std::vector<double>>* data) {
    Problem problem;

    // Set up the only cost function (also known as residual). This uses
    // auto-differentiation to obtain the derivative (jacobian).
    for (int sender = 0; sender < data[0].size(); sender++) {
        std::vector<double> dataPoint = data[0][sender];
        problem.AddResidualBlock(
            new AutoDiffCostFunction<Residual0, 1, 1, 1, 1>(
                new Residual0(dataPoint[0])),
            nullptr,
            &senders[0][sender][0], &senders[0][sender][1], &senders[0][sender][2]);
        problem.AddResidualBlock(
            new AutoDiffCostFunction<Residual1, 1, 1, 1, 1, 1>(
                new Residual1(dataPoint[1])),
            nullptr,
            &recievers[0][0], &senders[0][sender][0], &senders[0][sender][1], &senders[0][sender][2]);
        problem.AddResidualBlock(
            new AutoDiffCostFunction<Residual2, 1, 1, 1, 1, 1, 1>(
                new Residual2(dataPoint[2])),
            nullptr,
            &recievers[0][1], &recievers[0][2], &senders[0][sender][0], &senders[0][sender][1], &senders[0][sender][2]);
        problem.AddResidualBlock(
            new AutoDiffCostFunction<Residual3, 1, 1, 1, 1, 1, 1, 1>(
                new Residual3(dataPoint[3])),
            nullptr,
            &recievers[0][3], &recievers[0][4], &recievers[0][5], &senders[0][sender][0], &senders[0][sender][1], &senders[0][sender][2]);

    }

    // Run the solver!
    Solver::Options options;
    options.max_num_iterations = 1000;
//     options.minimizer_progress_to_stdout = true;
    Solver::Summary summary;
    Solve(options, &problem, &summary);
//     std::cout << summary.BriefReport() << "\n";
//     std::cout << "x0 : " << x0 << "\n";
//     std::cout << "x1 : " << x1 << "\n";
//     std::cout << "x2 : " << x2 << "\n";
//     std::cout << "x3 : " << x3 << "\n";
//     std::cout << "x4 : " << x4 << "\n";
//     std::cout << "x5 : " << x5 << "\n";



}

class MexFunction : public matlab::mex::Function {

public:
    void operator()(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs) {
//         checkArguments(outputs, inputs);
        matlab::data::TypedArray<double> initialRin = std::move(inputs[0]);
        matlab::data::TypedArray<double> initialSin = std::move(inputs[1]);
        matlab::data::TypedArray<double> din = std::move(inputs[2]);
        std::vector<double> initialR;
        for(auto elem : initialRin){
            initialR.push_back(elem);
        }


        std::vector<std::vector<double>> initialS;
        int i = 0;
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
            if(i%4==0){
                d.push_back(std::vector<double>());
            }
            d.back().push_back(elem);
            i++;
        }

        
        optBundling(&initialR, &initialS, &d);
        using namespace matlab::data;

        ArrayFactory factory;

        outputs[0] = factory.createArray<double>({ 3,4 });
        for(int i = 0; i<3; i++){
            for(int j = 0; j<4; j++){
                outputs[0][i][j] = 0.0;
            }
        }
        outputs[0][0][1] = initialR[0];
        outputs[0][0][2] = initialR[1];
        outputs[0][1][2] = initialR[2];
        outputs[0][0][3] = initialR[3];
        outputs[0][1][3] = initialR[4];
        outputs[0][2][3] = initialR[5];

        outputs[1] = factory.createArray<double>({ 3, nbrSenders });
        for(int i = 0; i<nbrSenders; i++){
            for(int j = 0; j<3; j++){
                outputs[1][j][i] = initialS[i][j];
            }
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