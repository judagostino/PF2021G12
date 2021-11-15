export class ChangePassword {
    lastPassword: string;
    newPassword: string;
    confirmPassword: string;

    constructor() {
        this.lastPassword = null;
        this.newPassword = null;
        this.confirmPassword = null;
    }
}
