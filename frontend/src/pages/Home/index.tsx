import React from "react";
import MainLayout from "../../layouts";
import { useUser } from "../../services/queries/useUser";
const index = () => {
  // const { user } = useUser();

  return (
    <MainLayout>
      <div className="flex items-center justify-center h-screen">
        <div className="text-center">
          <h1 className="text-2xl">Centered Content</h1>
          <p>Home page </p>
        </div>
      </div>
    </MainLayout>
  );
};

export default index;
