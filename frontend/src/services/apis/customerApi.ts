import axios from "axios";

const API_HOST = import.meta.env.VITE_API_HOST;

export const getCustomers = async () => {
  try {
    const response = await axios.get(`${API_HOST}/store/customer/`);
    return response.data;
  } catch (error) {
    console.error("Error fetching suppliers:", error);
    throw error;
  }
};

//create data
export const addCustomer = async (data) => {
  try {
    const response = await axios.post(
      `${API_HOST}/store/customer/`,
      data,
      // authorizationHeaders,
    );
    return response.data;
  } catch (error) {
    console.error("Error adding biomass:", error);
    throw error;
  }
};
