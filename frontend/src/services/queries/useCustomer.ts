import { getCustomers, addCustomer } from "../apis/customerApi";
import { useMutation, useQueryClient } from "@tanstack/react-query";

export const useAddCustomerMutation = () => {
  const queryClient = useQueryClient();

  const getOrCreateCustomer = async (user) => {
    const customers = await getCustomers();
    // Find if the customer already exists
    const existingCustomer = customers.find(
      (customer) => customer.line_user_id === user.sub,
    );

    // If customer exists, return the existing customer's id
    if (existingCustomer) {
      return existingCustomer;
    }
    return addCustomer({
      name: user.name,
      line_user_id: user.sub,
    });
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
