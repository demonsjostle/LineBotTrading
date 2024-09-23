import React from "react";
import MainLayout from "../../layouts";
import { usePackagesQuery } from "../../services/queries/usePackage";
import { useNavigate } from "react-router-dom";
import { useUser } from "../../services/queries/useUser";

interface Package {
  id: number;
  name: string;
  price: number;
  description: string;
  duration: number;
}

const index = () => {
  const { packages, isLoading } = usePackagesQuery();
  const navigate = useNavigate();
  const { user } = useUser();

  // Function to handle "Choose Plan" button click
  const handleChoosePlan = (selectedPackage: Package) => {
    if (!user) {
      navigate("/login");
    } else {
      navigate("/subscription", { state: { selectedPackage } }); // Pass selectedPackage as state
    }
  };

  return (
    <MainLayout>
      <div className="container mx-auto p-8 mt-24">
        <h1 className="text-4xl font-extrabold text-center mb-8 text-gray-900">
          Pricing Plans
        </h1>
        {isLoading ? (
          <p className="text-center text-xl text-gray-600">Loading...</p>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {packages && packages.length > 0 ? (
              packages.map((packageItem: Package) => (
                <div
                  key={packageItem.id}
                  className="border border-gray-300 rounded-lg shadow-lg overflow-hidden transition-transform transform hover:scale-105 bg-white"
                >
                  <div className="p-6 text-center">
                    <h2 className="text-2xl font-semibold text-blue-600 mb-2">
                      {packageItem.name}
                    </h2>
                    <p className="text-gray-600 mb-4">
                      {packageItem.description || "No description available."}
                    </p>
                    <div className="text-4xl font-bold text-gray-800 mb-4">
                      ฿{packageItem.price}
                    </div>
                    <div className="text-4xl text-gray-800 mb-4">
                      {packageItem.duration} วัน
                    </div>
                    <button
                      className={`w-full bg-blue-600 text-white py-3 rounded-lg shadow-md transition duration-300 ${isLoading
                          ? "cursor-not-allowed opacity-50"
                          : "hover:bg-blue-700"
                        }`}
                      disabled={isLoading}
                      onClick={() => handleChoosePlan(packageItem)} // Handle button click
                    >
                      Choose Plan
                    </button>
                  </div>
                </div>
              ))
            ) : (
              <h1 className="text-center text-red-500 text-xl">
                No packages available
              </h1>
            )}
          </div>
        )}
      </div>
    </MainLayout>
  );
};

export default index;
