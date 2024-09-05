import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import Main from "./routes";
import { BrowserRouter } from "react-router-dom";
import "./assets/styles/Global.styles.css";

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <BrowserRouter>
      <Main />
    </BrowserRouter>
  </StrictMode>,
);
