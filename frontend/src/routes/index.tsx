import React, { useEffect } from "react";
import AuthRoutes from "./AuthRoutes";
import UnAuthRoutes from "./UnAuthRoutes";
import { useNavigate } from "react-router-dom";

const index = () => {
  const navigate = useNavigate();
  const user: boolean = true;

  // useEffect(() => {
  //   if (!user) {
  //     navigate("/login");
  //   }
  // }, [user]);
  return <>{user ? <AuthRoutes /> : <UnAuthRoutes />}</>;
};

export default index;
