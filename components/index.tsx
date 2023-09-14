import AdminView from "./Admin";
import UserView from "./User";

export default function DApp() {
    return (
        <div>
            <AdminView />
            <hr />
            <br />

            <UserView />
        </div>
    );
}