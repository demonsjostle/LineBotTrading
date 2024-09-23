import { useQuery } from "@tanstack/react-query";
import { getPackages } from "../apis/packageApi";
export const usePackagesQuery = () => {
  const {
    data: packages,
    isError,
    error,
    isLoading,
  } = useQuery({
    queryKey: ["packages"],
    queryFn: () => getPackages(),
    // initialData: userLocalStorage.getUser,
    refetchOnMount: false,
    refetchOnWindowFocus: false,
    refetchOnReconnect: true,
  });

  return {
    packages: packages ?? null,
    isLoading,
  };
};
