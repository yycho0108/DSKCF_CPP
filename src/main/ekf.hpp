#ifndef __EKF_HPP__
#define __EKF_HPP__

#include <opencv2/core/core.hpp>

class EKF{
	using mat_t = cv::Mat2f;
	private:
		bool dynamic_params;

		mat_t  X,P,Q,R;
		// X = State Vector
		// P = Covariance
		// Q = Process Noise
		// R = Measurement Noise
		mat_t F,H, F_t, H_t;
		// F = jacobian of transition function
		// H = jacobian of observation function

	public:
		EKF(bool dynamic_params){
			if(!dynamic_params){
				getH(H);
				cv::transpose(H, H_t);
				getF(F);
				cv::transpose(F, F_t);
			}
		}

		mat_t predict(){
			X = f(X);

			if(dynamic_params){
				getF(F);
				cv::transpose(F, F_t);
			}

			P = F*P*F_t + Q;
			return X;
		}

		mat_t update(const mat_t& z){
			if(dynamic_params){
				getH(H);
				cv::transpose(H, H_t);
			}

			return X;
		}

		virtual mat_t h(mat_t& x){
			//Mapping Function
			// map x --> z
		}
		virtual void getH(mat_t& H){
			// jacobian of H
		}
		virtual mat_t f(mat_t& X){
			//transition function
		}
		virtual void getF(mat_t& F){
			// jacobian of f
		}
};

#endif
