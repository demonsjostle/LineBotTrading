import React, { useEffect, useState } from "react";
import MainLayout from "../../layouts";
import { useUser } from "../../services/queries/useUser";
import {
  useAddCustomerMutation,
  useUpdateCustomerMutation,
} from "../../services/queries/useCustomer";
import Loading from "../../components/Loading";

interface Customer {
  name: string;
  line_user_id: string;
  picture_url: string | null;
  phone: string | null;
  email: string | null;
  mt5_id: string | null;
  current_plan: string | null;
  expired_plan: string | null;
}

const index = () => {
  const [customer, setCustomer] = useState<Customer>({
    name: "",
    line_user_id: "",
    picture_url: "",
    phone: "",
    email: "",
    mt5_id: "",
    current_plan: "",
    expired_plan: "",
  });
  const { user, isLoading } = useUser();
  const { mutate: addCustomer, isPending: isAddCustomerPending } =
    useAddCustomerMutation();
  const { mutate: updateCustomer, isPending: isUpdateCustomerPending } =
    useUpdateCustomerMutation();
  if (isLoading) {
    return (
      <MainLayout>
        <Loading />
      </MainLayout>
    );
  }

  useEffect(() => {
    setCustomer({
      name: user.name,
      picture_url: user?.picture,
      line_user_id: user.sub,
    });
    addCustomer(user, {
      onSuccess: (customerData) => {
        setCustomer(customerData);
      },
    });
  }, [user]);

  if (isAddCustomerPending) {
    return (
      <MainLayout>
        <Loading />
      </MainLayout>
    );
  }
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setCustomer({ ...customer, [e.target.name]: e.target.value });
  };

  const handleSave = () => {
    const data = {
      phone: customer.phone || "",
      email: customer.email || "",
      mt5_id: customer.mt5_id || "",
    };
    updateCustomer(
      {
        data,
        line_user_id: customer.line_user_id,
      },
      {
        onSuccess: (data) => {},
      },
    );
  };

  return (
    <MainLayout>
      <div className="flex justify-center items-center min-h-screen bg-gray-100 ">
        {customer && (
          <div className="flex flex-col items-center p-8 bg-white rounded-lg shadow-2xl max-w-lg w-full mx-4">
            <h1 className="text-3xl font-bold text-gray-800 mb-6">
              Welcome, {customer.name}!
            </h1>

            {/* User Avatar */}
            {user.picture && (
              <img
                src={user.picture}
                alt={customer.name}
                className="w-28 h-28 rounded-full mb-6 shadow-lg object-cover"
              />
            )}

            {/* Line user id (Non-editable) */}
            <div className="w-full mb-4">
              <h2 className="text-lg font-medium text-gray-700">
                Line User ID (Non-editable)
              </h2>
              <p className="text-gray-600 bg-gray-200 p-2 rounded-md">
                {customer.line_user_id}
              </p>
            </div>

            {/* Name (Non-editable) */}
            <div className="w-full mb-4">
              <h2 className="text-lg font-medium text-gray-700">
                Name (Non-editable)
              </h2>
              <p className="text-gray-600 bg-gray-200 p-2 rounded-md">
                {customer.name}
              </p>
            </div>

            {/* Email (Editable) */}
            <div className="w-full mb-4">
              <h2 className="text-lg font-medium text-gray-700">
                Email (Editable)
              </h2>
              <input
                type="email"
                name="email"
                value={customer.email || ""}
                onChange={handleChange}
                className="text-gray-600 bg-white p-2 rounded-md w-full border border-gray-300"
              />
            </div>

            {/* Phone (Editable) */}
            <div className="w-full mb-4">
              <h2 className="text-lg font-medium text-gray-700">
                Phone (Editable)
              </h2>
              <input
                type="text"
                name="phone"
                value={customer.phone || ""}
                onChange={handleChange}
                className="text-gray-600 bg-white p-2 rounded-md w-full border border-gray-300"
              />
            </div>

            {/* MT5 ID (Editable) */}
            <div className="w-full mb-4">
              <h2 className="text-lg font-medium text-gray-700">
                MT5 ID (Editable)
              </h2>
              <input
                type="text"
                name="mt5_id"
                value={customer.mt5_id || ""}
                onChange={handleChange}
                className="text-gray-600 bg-white p-2 rounded-md w-full border border-gray-300"
              />
            </div>

            {/* Current Plan (Non-editable) */}
            <div className="w-full mb-4">
              <h2 className="text-lg font-medium text-gray-700">
                Current Plan (Non-editable)
              </h2>
              <p className="text-gray-600 bg-gray-200 p-2 rounded-md">
                {customer.current_plan ? customer.current_plan : "-"}
              </p>
            </div>

            {/* Expired Plan (Non-editable) */}
            <div className="w-full">
              <h2 className="text-lg font-medium text-gray-700">
                Expired Plan (Non-editable)
              </h2>
              <p className="text-gray-600 bg-gray-200 p-2 rounded-md">
                {customer.expired_plan ? customer.expired_plan : "-"}
              </p>
            </div>

            {/* Save button */}
            <button
              onClick={handleSave}
              className="mt-4 bg-blue-500 text-white px-4 py-2 rounded-md"
            >
              {isUpdateCustomerPending ? (
                <svg
                  className="animate-spin h-5 w-5 text-white"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                >
                  <circle
                    className="opacity-25"
                    cx="12"
                    cy="12"
                    r="10"
                    stroke="currentColor"
                    strokeWidth="4"
                  ></circle>
                  <path
                    className="opacity-75"
                    fill="currentColor"
                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
                  ></path>
                </svg>
              ) : (
                "Save"
              )}
            </button>
          </div>
        )}
      </div>
    </MainLayout>
  );
};

export default index;
