import MainLayout from "../../layouts";
const index = () => {
  return (
    <MainLayout>
      <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100 p-6">
        <div className="bg-white rounded-lg shadow-lg p-8 max-w-4xl w-full">
          <h1 className="text-4xl font-bold text-center text-gray-800 mb-6">
            About Us
          </h1>

          <div className="flex flex-col md:flex-row items-center">
            <div className="md:w-1/2 md:pr-6 mb-6 md:mb-0">
              <img
                src="https://st.depositphotos.com/1003593/3947/i/450/depositphotos_39479909-stock-photo-about-us-blue-marker.jpg"
                alt="About Us"
                className="rounded-lg shadow-md w-full"
              />
            </div>
            <div className="md:w-1/2">
              <p className="text-gray-600 mb-4">
                Welcome to our platform! We are passionate about creating
                innovative solutions that make life easier for our users. With a
                team of dedicated professionals, we focus on delivering
                high-quality services that meet the needs of our community.
              </p>
              <p className="text-gray-600 mb-4">
                Our vision is to continuously innovate and provide excellent
                service. Whether you're a long-time user or new to our platform,
                we are excited to have you with us.
              </p>
              <p className="text-gray-600">
                Thank you for choosing us. We are committed to making your
                experience as seamless and enjoyable as possible.
              </p>
            </div>
          </div>

          <div className="mt-8 text-center">
            <h2 className="text-2xl font-semibold text-gray-700">
              Our Mission
            </h2>
            <p className="text-gray-600 mt-4">
              To deliver exceptional services and create a platform that brings
              value and innovation to our users.
            </p>
          </div>
        </div>
      </div>
    </MainLayout>
  );
};

export default index;
