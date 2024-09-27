import { Routes, Route } from "react-router-dom";
import PageNotFound from "../pages/PageNotFound";
import Home from "../pages/Home";
import Pricing from "../pages/Pricing";
import About from "../pages/About";
import Profile from "../pages/Profile";
import Settings from "../pages/Settings";
import Subscription from "../pages/Subscription";
const AuthRoutes = () => {
  return (
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/pricing" element={<Pricing />} />
      {/* <Route path="/about" element={<About />} /> */}
      <Route path="/profile" element={<Profile />} />
      <Route path="/settings" element={<Settings />} />
      <Route path="/subscription" element={<Subscription />} />
      <Route path="*" element={<PageNotFound />} />
    </Routes>
  );
};

export default AuthRoutes;
