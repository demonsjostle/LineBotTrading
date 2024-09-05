import React from "react";
import { Routes, Route } from "react-router-dom";
import PageNotFound from "../pages/PageNotFound";
import Home from "../pages/Home";
const AuthRoutes = () => {
  return (
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="*" element={<PageNotFound />} />
    </Routes>
  );
};

export default AuthRoutes;
