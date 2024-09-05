import React, { ReactNode } from "react";
interface IndexProps {
  children?: ReactNode;
}
const index: React.FC<IndexProps> = ({ children }) => {
  return <React.Fragment>{children}</React.Fragment>;
};

export default index;
