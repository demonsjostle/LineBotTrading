import React from "react";
import MainLayout from "../../layouts";
import { useUser } from "../../services/queries/useUser";
const index = () => {
  const { user, isLoading } = useUser();
  if (isLoading) {
    return <MainLayout>Loading...</MainLayout>;
  }

  return (
    <MainLayout>
      <div className="flex justify-center items-center min-h-screen -mt-24">
        {user && (
          <div className="flex flex-col items-center p-6 bg-white rounded-lg shadow-md">
            <h1 className="text-2xl font-semibold mb-4">
              Welcome, {user.name}!
            </h1>
            {user.picture && (
              <img
                src={user.picture}
                alt={user.name}
                className="w-24 h-24 rounded-full mb-4 shadow-lg"
              />
            )}
            {/* Sub (ID) */}
            <div className="flex justify-center mt-4">
              <h2 className="text-xl font-medium mr-2">Sub (ID):</h2>
              <p className="text-gray-600">{user.sub}</p>
            </div>
            {/* Name */}
            <div className="flex justify-center mt-4">
              <h2 className="text-xl font-medium mr-2">Name:</h2>
              <p className="text-gray-600">{user.name}</p>
            </div>
            {/* Email */}
            <div className="flex justify-center mt-4">
              <h2 className="text-xl font-medium mr-2">Email:</h2>
              <p className="text-gray-600">{user.email ? user.email : "-"}</p>
            </div>
          </div>
        )}
      </div>
    </MainLayout>
  );
};

export default index;
