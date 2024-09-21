import React from "react";
import { Routes, Route } from "react-router-dom";
import Login from "../pages/Login";
import PageNotFound from "../pages/PageNotFound";
import Pricing from "../pages/Pricing";
import Home from "../pages/Home";
import About from "../pages/About";
const UnAuthRoutes = () => {
  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route path="/" element={<Home />} />
      <Route path="/pricing" element={<Pricing />} />
      <Route path="/about" element={<About />} />
      <Route path="*" element={<PageNotFound />} />
    </Routes>
  );
};

export default UnAuthRoutes;
