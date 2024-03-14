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
    trusted?: boolean;
    notifications?: boolean;
    blocked?: boolean;
    assist?: string;
    foundationName?: string;
    address?: string;
    urlWeb?: string;
    description?: string;
    descriptionParagraphs?: string[];
    userFacebook?: string;
    userInstagram?: string;
    userLinkedin?: string;
    userX?: string;
}