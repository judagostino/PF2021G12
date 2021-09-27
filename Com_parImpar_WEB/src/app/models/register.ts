export class Register{
    id: number;
    firstName: string;
    lastName: string;
    email: string;
    confirmEmail: Date;
    userName: string;
    password: string;
    confirmPassword: string;
    confirmCode?: string;
    dateBrirth?: Date;

    constructor() {
        this.id = 0;
        this.firstName = null;
        this.lastName = null;
        this.email = null;
        this.confirmEmail = null;
        this.userName = null;
        this.password = null;
        this.confirmPassword = null;
        this.confirmCode = null;
        this.dateBrirth = null;
    }
}