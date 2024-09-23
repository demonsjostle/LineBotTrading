import AuthRoutes from "./AuthRoutes";
import UnAuthRoutes from "./UnAuthRoutes";
import { useUser } from "../services/queries/useUser";
import Loading from "../components/Loading";

const index = () => {
  const { user, isLoading } = useUser();

  return (
    <>
      {isLoading ? (
        <>
          <Loading />
        </>
      ) : (
        <>{user ? <AuthRoutes /> : <UnAuthRoutes />}</>
      )}
    </>
  );
};

export default index;
