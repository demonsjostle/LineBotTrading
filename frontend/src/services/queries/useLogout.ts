import { useQueryClient } from "@tanstack/react-query";
import { useCallback } from "react";
import { useNavigate } from "react-router-dom";
import liff from "@line/liff";

export function useLogout() {
  const queryClient = useQueryClient();
  const navigate = useNavigate();

  const onLogout = useCallback(() => {
    const LIFF_ID: string = import.meta.env.VITE_LIFF_ID;

    liff
      .init({
        liffId: LIFF_ID, // Use own liffId
      })
      .then(() => {
        if (liff.isLoggedIn()) {
          liff.logout();
          queryClient.setQueryData(["user"], null);
          navigate("/");
        }
      })
      .catch((err) => {
        console.log(err);
      });
  }, [navigate, queryClient]);

  return onLogout;
}
