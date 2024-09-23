import { getCustomer, addCustomer, updateCustomer } from "../apis/customerApi";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useSnackbar } from "notistack";
import { useQuery } from "@tanstack/react-query";

export const useAddCustomerMutation = () => {
  const queryClient = useQueryClient();

  const getOrCreateCustomer = async (user) => {
    try {
      const customer = await getCustomer(user.sub);

      if (customer) {
        console.log(customer);
        return customer;
      }
    } catch (error) {
      return await addCustomer({
        name: user.name,
        line_user_id: user.sub,
        picture_url: user.picture,
      });
    }
  };

  return useMutation({
    mutationFn: (user) => getOrCreateCustomer(user),
    onSuccess: () => {
      // Success actions
    },
    onError: (error) => {
      // Error actions
    },
  });
};

export const useUpdateCustomerMutation = () => {
  const { enqueueSnackbar } = useSnackbar();
  return useMutation({
    mutationFn: ({
      data,
      line_user_id,
    }: {
      data: { phone?: string; email?: string; mt5_id?: string };
      line_user_id: string;
    }) => updateCustomer(data, line_user_id),
    onSuccess: () => {
      // Success actions
      enqueueSnackbar("อัพเดทข้อมูลสำเร็จ", {
        variant: "success",
      });
    },
    onError: (error) => {
      const errorData = error?.response?.data;

      if (errorData) {
        // Loop through each key in errorData (e.g., mt5_id, email, etc.)
        Object.keys(errorData).forEach((field) => {
          // Each field might have multiple error messages (usually an array)
          errorData[field].forEach((message: string) => {
            console.log(`${field}: ${message}`);
            enqueueSnackbar(`${field}: ${message}`, {
              variant: "error",
            });
          });
        });
      } else {
        // Fallback error message if there's no specific data
        console.log("An unexpected error occurred.");
        enqueueSnackbar("An unexpected error occurred.", {
          variant: "error",
        });
      }
    },
    onMutate: () => {},
  });
};

export const useGetCustomerQuery = (line_user_id: string) => {
  return useQuery({
    queryKey: ["customer", line_user_id],
    queryFn: () => getCustomer(line_user_id),
    // initialData: userLocalStorage.getUser,
    enabled: !!line_user_id,
    refetchOnMount: false,
    refetchOnWindowFocus: false,
    refetchOnReconnect: true,
  });
};
