import { useMutation, useQueryClient } from "@tanstack/react-query";
import { addOrder } from "../apis/orderApi";
import { useSnackbar } from "notistack";
export const useAddOrderMutation = () => {
  const queryClient = useQueryClient();
  const { enqueueSnackbar } = useSnackbar();

  return useMutation({
    mutationFn: ({ packageId, customerId, paymentSlip }) =>
      addOrder({
        packageId: packageId,
        customerId: customerId,
        paymentSlip: paymentSlip,
      }),
    onSuccess: () => {
      enqueueSnackbar("สำเร็จ", {
        variant: "success",
      });
    },
    onError: (error) => {
      // Error actions
      enqueueSnackbar(error.message, {
        variant: "error",
      });
    },
  });
};
