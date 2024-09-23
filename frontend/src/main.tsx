import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import Main from "./routes";
import { BrowserRouter } from "react-router-dom";
import "./assets/styles/Global.styles.css";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { SnackbarProvider } from "notistack";

const queryClient = new QueryClient();
createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <QueryClientProvider client={queryClient}>
      <SnackbarProvider>
        <BrowserRouter>
          <Main />
        </BrowserRouter>
      </SnackbarProvider>
    </QueryClientProvider>
  </StrictMode>,
);
