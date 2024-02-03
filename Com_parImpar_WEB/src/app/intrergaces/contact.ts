export interface Contact {
    id: number;
    email?: string;
    confirmEmail?: string;
    userName?: string;
    name?: string;
    lastName?: string;
    firstName?: string;
    password?: string;
    confirmPassword?: string;
    dateBrirth?: Date;
    imageUrl?: string;
    auditor?: boolean;
    notifications?: boolean;
}