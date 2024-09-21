import React, { useEffect } from "react";
import AuthRoutes from "./AuthRoutes";
import UnAuthRoutes from "./UnAuthRoutes";
import { useNavigate } from "react-router-dom";
import { useUser } from "../services/queries/useUser";

const index = () => {
  const navigate = useNavigate();

  const { user } = useUser();

  useEffect(() => {
    if (!user) {
      // navigate("/login");
    }
  }, [user]);
  return <>{user ? <AuthRoutes /> : <UnAuthRoutes />}</>;
};

export default index;
