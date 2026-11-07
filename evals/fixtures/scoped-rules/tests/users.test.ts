import { resetUsers, getUser } from "../src/api/users";

resetUsers();
console.assert(getUser("1") === undefined);
