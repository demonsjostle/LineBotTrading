import MainLayout from "../../layouts";
import Promotion1 from "../../assets/images/promotions/100.jpg";
import Promotion2 from "../../assets/images/promotions/500.jpg";
import Promotion3 from "../../assets/images/promotions/1000.jpg";

import { useUser } from "../../services/queries/useUser";
import { useNavigate } from "react-router-dom";
const index = () => {
  const { user } = useUser();
  const navigate = useNavigate();
  // Function to handle "Choose Plan" button click
  const handleChoosePlan = () => {
    if (!user) {
      navigate("/login");
    } else {
      // navigate("/subscription", { state: { selectedPackage } }); // Pass selectedPackage as state
      navigate("/pricing");
    }
  };
  return (
    <MainLayout>
      <div className="flex flex-col items-center h-screen mt-20">
        {/* Image container */}
        <h1 className="text-4xl mb-6">โปรโมชั่น</h1>
        <div className="flex flex-col md:flex-row md:space-x-4 space-y-4 md:space-y-0">
          <img
            src={Promotion1}
            alt="Image 1"
            className="w-80 h-80 object-cover"
            onClick={() => handleChoosePlan()}
          />
          <img
            src={Promotion2}
            alt="Image 2"
            className="w-80 h-80 object-cover"
            onClick={() => handleChoosePlan()}
          />
          <img
            src={Promotion3}
            alt="Image 3"
            className="w-80 h-80 object-cover"
            onClick={() => handleChoosePlan()}
          />
        </div>
      </div>
    </MainLayout>
  );
};

export default index;
