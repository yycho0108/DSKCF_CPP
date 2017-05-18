#include <ros/ros.h>
#include <cv_bridge/cv_bridge.h>
#include <message_filters/sync_policies/approximate_time.h>

void cv2ros(const sensor_msgs::ImageContPtr& msg, cv::Mat& out, const std::string& enc = snesor_msgs::image_encodings::BGR8){
	cv_bridge::CvImagePtr cv_ptr;
	try{
		cv_ptr = cv_bridge::toCvCopy(msg, enc);
		if(cv_ptr->image.empty()){
			return;
		}
	}catch(cv_bridge::Exception &e){
		ROS_ERROR("Could not convert from '%s' to 'bgr8'.", msg->encoding.c_str());
		return;
	}
	cv_ptr->image.copyTo(rgb);
}

typedef message_filters::sync_policies::ApproximateTime<sensor_msgs::Image, stereo_msgs::DisparityImage> ApproximatePolicy;
typedef message_filters::Synchronizer<ApproximatePolicy> ApproximateSync;

class DSKCFTrackerROS{
	protected:
		ros::NodeHandle* _nh;
		image_transport::Publisher _res_pub;
		boost::shared_ptr<ApproximateSync> _approximate_sync; // subscribe

		CFTracker* _tracker;
		cv::Mat rgb;
		cv::Mat depth;

	public:
		int init(ros::NodeHandle& nh){
			_nh = &nh;
			image_transport::ImageTransport it(nh);

			image_transport::SubscriberFilter rgb_sub, depth_sub;

			rgb_sub.subscribe(it, img_topic.c_str(), 1, "raw");
			depth_sub.subscribe(it, depth_topic.c_str(), 1, "raw");

			_approximate_sync.reset(new ApproximateSync(ApproximatePolicy(queue_size),rgb_sub,depth_sub));
			// maybe right syntax?
			_approximate_sync->registerCallback(boost::bind(&DSKCFTrackerROS::frame_cb, this, _1, _2));

			_res_pub = it.advertise(out_topic.c_str(), 1);
		}

		void frame_cb(const sensor_msgs::ImageConstPtr& rgb_msg, const stereo_msgs::DisparityImageConstPtr& depth_msg){
			cv2ros(rgb_msg, rgb);
			cv2ros(depth_msg->image, depth, sensor_msgs::image_encodings::TYPE_32FC1);
			// DO_STUFF
			_res_pub.publish(
		}
};

int main(){

}
