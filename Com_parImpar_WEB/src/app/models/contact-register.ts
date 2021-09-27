export class ContactRegistrer {
    id?: number;
    email?: string;
    confirmEmail?: string;
    userName?: string;
    lastName?: string;
    firstName?: string;
    password?: string;
    confirmPassword?: string;
    confirmCode?: string;
    codeRecover?: string;
    dateBrirth?: Date;

    constructor() {
        this.id = 0;
        this.email = null;
        this.confirmEmail = null;
        this.userName = null;
        this.lastName = null;
        this.firstName = null;
        this.password = null;
        this.confirmPassword = null;
        this.confirmCode = null;
        this.codeRecover = null;
        this.dateBrirth = null;
    }
}