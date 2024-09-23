import React, { useEffect } from "react";
import AuthRoutes from "./AuthRoutes";
import UnAuthRoutes from "./UnAuthRoutes";
import { useNavigate } from "react-router-dom";
import { useUser } from "../services/queries/useUser";
import Loading from "../components/Loading";

const index = () => {
  const navigate = useNavigate();

  const { user, isLoading } = useUser();

  useEffect(() => {
    if (!user) {
      // navigate("/login");
    }
  }, [user]);

  return (
    <>
      {isLoading ? (
        <>
          <Loading />
        </>
      ) : (
        <>{user ? <AuthRoutes /> : <UnAuthRoutes />}</>
      )}
    </>
  );
};

export default index;
