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


class MexFunction : public matlab::mex::Function {

public:
    void operator()(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs) {
//         checkArguments(outputs, inputs);
        matlab::data::TypedArray<double> initialR = std::move(inputs[0]);
        std::cout << "hej " << inputs[0].getDimensions()[0]; 
        matlab::data::TypedArray<double> inD2 = std::move(inputs[1]);
        double vals[6]{};
        int i = 0;
        for(auto elem : initialR){
            vals[i++] = elem;
        }
        std::vector<std::vector<double>> data;
        
        i = 0;
        for(auto elem : inD2){
            if(i%4==0){
                data.push_back(std::vector<double>());
            }
            data.back().push_back(elem);
            i++;
        }
        using namespace matlab::data;

        ArrayFactory factory;

        outputs[0] = factory.createArray<double>({ 6,1 });
        for(int i = 0; i<6; i++){
            outputs[0][i] = vals[i];
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
// It might be easier if I change input to
        if (inputs[0].getDimensions().size() != 1) {
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
                0, std::vector<matlab::data::Array>({ factory.createScalar("Input must be 3-by-n dimension") }));
        }
        
        if (inputs[1].getDimensions()[0] != 3) {
            matlabPtr->feval(u"error", 
                0, std::vector<matlab::data::Array>({ factory.createScalar("Input must be 3-by-n dimension") }));
        }
    }
    

    

};