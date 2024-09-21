import liff from "@line/liff";
import { useQuery } from "@tanstack/react-query";
// import { useEffect } from "react";

interface User {
  sub: string;
  name: string;
  picture?: string; // Optional field
  email?: string; // Optional field
}

export const useUser = () => {
  const getLineUser = (): Promise<User | null> => {
    const LIFF_ID: string = import.meta.env.VITE_LIFF_ID;

    return liff
      .init({
        liffId: LIFF_ID, // Use own liffId
      })
      .then(() => {
        // start to use LIFF's api
        if (liff.isLoggedIn()) {
          const idToken = liff.getDecodedIDToken() as User;
          return idToken;
        } else {
          console.log("no login");
          return null;
        }
      })
      .catch((err) => {
        console.log(err);
        return null;
      });
  };

  const {
    data: user,
    isError,
    error,
    isLoading,
  } = useQuery({
    queryKey: ["user"],
    queryFn: () => getLineUser(),
    // initialData: userLocalStorage.getUser,
    refetchOnMount: false,
    refetchOnWindowFocus: false,
    refetchOnReconnect: true,
  });

  // useEffect(() => {
  //   if (isError) {
  //     if (!user) {
  //       userLocalStorage.removeUser();
  //     }
  //   }
  // }, [isError]);
  //
  // useEffect(() => {
  //   if (!user) userLocalStorage.removeUser();
  //   else userLocalStorage.saveUser(user);
  // }, [user]);

  return {
    user: user ?? null,
    isLoading,
  };
};
