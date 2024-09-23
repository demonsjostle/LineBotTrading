import axios from "axios";

const API_HOST = import.meta.env.VITE_API_HOST;

export const getOrders = async () => {
  try {
    const response = await axios.get(`${API_HOST}/store/order/`);
    return response.data;
  } catch (error) {
    console.error("Error fetching suppliers:", error);
    throw error;
  }
};

//create data
export const addOrder = async (data: {
  packageId: number;
  customerId: number;
  paymentSlip: File;
}) => {
  try {
    const formData = new FormData();
    formData.append("package", data.packageId.toString());
    formData.append("customer", data.customerId.toString());
    formData.append("payment_slip", data.paymentSlip);
    const response = await axios.post(`${API_HOST}/store/order/`, formData, {
      headers: {
        "Content-Type": "multipart/form-data", // Set the content type
      },
    });
    return response.data;
  } catch (error) {
    console.error("Error adding biomass:", error);
    throw error;
  }
};
