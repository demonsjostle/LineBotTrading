import MainLayout from "../../layouts";
import Promotion1 from "../../assets/images/promotions/100.jpg";
import Promotion2 from "../../assets/images/promotions/500.jpg";
import Promotion3 from "../../assets/images/promotions/1000.jpg";
const index = () => {
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
          />
          <img
            src={Promotion2}
            alt="Image 2"
            className="w-80 h-80 object-cover"
          />
          <img
            src={Promotion3}
            alt="Image 3"
            className="w-80 h-80 object-cover"
          />
        </div>
      </div>
    </MainLayout>
  );
};

export default index;
