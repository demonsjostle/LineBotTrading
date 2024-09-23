import LineLogo from "../../assets/images/LINE_Brand_icon.png";
import liff from "@line/liff";

const index = () => {
  const handleLineLogin = () => {
    const LIFF_ID = import.meta.env.VITE_LIFF_ID;

    liff
      .init({
        liffId: LIFF_ID, // Use own liffId
      })
      .then(() => {
        // start to use LIFF's api
        if (!liff.isLoggedIn()) {
          liff.login();
        }
      })
      .catch((err) => {
        console.log(err);
      });
  };
  return (
    <div className="bg-gray-100 flex items-center justify-center min-h-screen">
      <div className="bg-white p-8 rounded-lg shadow-lg w-full max-w-md">
        <h2 className="text-2xl font-bold mb-6 text-center">Login</h2>

        <div className="mt-6">
          <div className="flex justify-center space-x-4">
            {/* Line OAuth */}
            <button
              onClick={() => handleLineLogin()}
              className="flex items-center justify-center w-full bg-green-500 text-white py-2 rounded-md hover:bg-green-600 focus:outline-none"
            >
              <img src={LineLogo} alt="LINE Logo" className="h-6 w-6 mr-2" />
              Line
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default index;
