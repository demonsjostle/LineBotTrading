import React, { useState } from "react";
import MainLayout from "../../layouts";
import { useLocation } from "react-router-dom";
import { useUser } from "../../services/queries/useUser";
import {
  useAddCustomerMutation,
  useGetCustomerQuery,
  useUpdateCustomerMutation,
} from "../../services/queries/useCustomer";
import { useAddOrderMutation } from "../../services/queries/useOrder";
import { useSnackbar } from "notistack";

const index = () => {
  const location = useLocation();
  const { selectedPackage } = location.state || {};
  const [isShowPaymentMethod, setIsShowPaymentMethod] = useState(false);

  const handlePlanCheckout = () => {
    setIsShowPaymentMethod(true);
    console.log("checkout", selectedPackage.id);
  };

  return (
    <MainLayout>
      <div className="container mx-auto p-8 mt-24 max-w-4xl">
        <div className="text-center mb-12">
          <h1 className="text-5xl font-extrabold text-gray-900">
            Subscription Plan
          </h1>
          <p className="text-lg text-gray-600 mt-4">
            Please review your selected plan and proceed with your subscription.
          </p>
        </div>

        {selectedPackage ? (
          <div className="bg-white rounded-lg shadow-xl p-8">
            <h2 className="text-3xl font-semibold text-blue-600 mb-4 text-center">
              {selectedPackage.name}
            </h2>
            <p className="text-center text-gray-600 mb-8">
              {selectedPackage.description ||
                "This plan offers a range of features to meet your needs."}
            </p>
            <div className="flex justify-center mb-8">
              <div className="bg-blue-100 rounded-full py-2 px-6">
                <span className="text-5xl font-bold text-blue-600">
                  ฿{selectedPackage.price}
                </span>
                <span className="text-xl text-gray-600"> / Month</span>
              </div>
            </div>
            <div className="flex justify-center">
              <button
                className="bg-blue-600 text-white py-3 px-8 rounded-lg shadow-lg hover:bg-blue-700 transition duration-300"
                onClick={() => handlePlanCheckout()}
              >
                Proceed to Checkout
              </button>
            </div>
          </div>
        ) : (
          <div className="bg-red-100 rounded-lg p-8 text-center">
            <h2 className="text-2xl font-semibold text-red-600 mb-4">
              No Subscription Plan Selected
            </h2>
            <p className="text-gray-600">Please go back and choose a plan.</p>
          </div>
        )}
      </div>
      {isShowPaymentMethod && (
        <React.Fragment>
          <PaymentMethod />
          <ConfirmPayment selectedPackage={selectedPackage} />
        </React.Fragment>
      )}
    </MainLayout>
  );
};

const PaymentMethod = () => {
  return (
    <div className="container mx-auto p-8 mt-10 max-w-4xl">
      <div className="bg-white rounded-lg shadow-xl p-8">
        <h1 className="text-5xl font-extrabold">ช่องทางชำระเงิน</h1>
      </div>
    </div>
  );
};

const ConfirmPayment = ({ selectedPackage }) => {
  const [paymentSlip, setPaymentSlip] = useState(null);
  const [isSlipUploaded, setIsSlipUploaded] = useState(false);
  const [mt5Id, setMt5Id] = useState("");
  const [successOrderKey, setSuccessOrderKey] = useState(null);
  const { user } = useUser();
  const { mutate: addCustomer, isError, error } = useAddCustomerMutation();
  const { mutate: addOrder } = useAddOrderMutation();
  const { mutate: updateCustomer } = useUpdateCustomerMutation();
  const { data: customer } = useGetCustomerQuery(user.sub);
  const { enqueueSnackbar } = useSnackbar();

  const handleImageUpload = (e) => {
    const file = e.target.files[0];
    if (file) {
      setPaymentSlip(file);
      setIsSlipUploaded(true);
    }
  };

  const handleSubmitPayment = () => {
    if (isSlipUploaded) {
      if (user) {
        addCustomer(user, {
          onSuccess: (customerData) => {
            if (!customer.mt5_id && !mt5Id) {
              enqueueSnackbar("Please enter your MT5 ID", {
                variant: "warning",
              });
              return;
            } else if (mt5Id) {
              const data = {
                mt5_id: mt5Id,
              };

              updateCustomer(
                { data, line_user_id: customerData.line_user_id },
                {
                  onSuccess: () => {
                    // Add order here after successful customer mutation
                    addOrder(
                      {
                        packageId: selectedPackage.id, // Pass selected package ID
                        customerId: customerData.id, // Pass customer ID
                        paymentSlip: paymentSlip, // Pass the uploaded payment slip
                      },
                      {
                        onSuccess: (orderData) => {
                          console.log("Order created successfully:", orderData);
                          setSuccessOrderKey(orderData.order_key);
                        },
                        onError: (orderError) => {
                          console.error("Order creation error:", orderError);
                        },
                      },
                    );
                  },
                },
              );
            } else {
              // Add order here after successful customer mutation
              addOrder(
                {
                  packageId: selectedPackage.id, // Pass selected package ID
                  customerId: customerData.id, // Pass customer ID
                  paymentSlip: paymentSlip, // Pass the uploaded payment slip
                },
                {
                  onSuccess: (orderData) => {
                    console.log("Order created successfully:", orderData);
                    setSuccessOrderKey(orderData.order_key);
                  },
                  onError: (orderError) => {
                    console.error("Order creation error:", orderError);
                  },
                },
              );
            }
          },
          onError: (error) => {
            console.error("Mutation error:", error);
          },
        });
      }
    } else {
      enqueueSnackbar("โปรดอัปโหลดสลิปเพื่อคอนเฟิร์มการจ่ายเงิน", {
        variant: "warning",
      });
    }
  };

  return (
    <div className="container mx-auto p-8 mt-10 max-w-4xl">
      <div className="bg-white rounded-lg shadow-xl p-8">
        <h1 className="text-4xl font-extrabold text-center text-gray-900 mb-6">
          ยืนยันการชำระเงิน
        </h1>
        <p className="text-lg text-gray-600 text-center mb-4">
          กรุณาตรวจสอบข้อมูลการชำระเงินและอัปโหลดหลักฐานการชำระเงินของคุณ
        </p>

        {/* Upload Payment Slip Section */}
        <div className="mb-6">
          <label className="block text-lg font-medium text-gray-700 text-center mb-4">
            อัปโหลดสลิปการชำระเงิน
          </label>
          <div className="flex justify-center">
            <input
              type="file"
              accept="image/*"
              onChange={handleImageUpload}
              className="hidden"
              id="payment-slip-upload"
            />
            <label
              htmlFor="payment-slip-upload"
              className="bg-blue-600 text-white py-3 px-8 rounded-lg shadow-lg hover:bg-blue-700 transition duration-300 cursor-pointer"
            >
              {isSlipUploaded ? "สลิปอัปโหลดแล้ว" : "อัปโหลดสลิป"}
            </label>
          </div>
          {isSlipUploaded && (
            <p className="text-green-600 text-center mt-4">
              {paymentSlip.name} อัปโหลดสำเร็จ!
            </p>
          )}
        </div>

        {/* Conditionally render mt5_id input */}
        {!customer?.mt5_id && (
          <div className="mb-6">
            <label className="block text-lg font-medium text-gray-700 text-center mb-4">
              กรุณากรอก MT5 ID
            </label>
            <div className="flex justify-center">
              <input
                type="text"
                value={mt5Id}
                onChange={(e) => setMt5Id(e.target.value)}
                className="border rounded-lg py-2 px-4 w-64 text-center"
                placeholder="Enter your MT5 ID"
              />
            </div>
          </div>
        )}

        {/* Confirm Payment Button */}
        <div className="flex justify-center">
          <button
            className="bg-green-600 text-white py-3 px-8 rounded-lg shadow-lg hover:bg-green-700 transition duration-300"
            onClick={handleSubmitPayment}
          >
            ยืนยันการชำระเงิน
          </button>
        </div>
        <div className="flex justify-center">
          {successOrderKey && (
            <p className="text-green-600 text-center mt-4">
              Order key ของคุณคือ: {successOrderKey}
            </p>
          )}
        </div>
      </div>
    </div>
  );
};

export default index;
