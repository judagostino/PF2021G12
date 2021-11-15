export interface ActionsLog {
    userActionLog: UserActionLog[];
    postViews: ViewrsActionLog[];
    eventViews: ViewrsActionLog[];
    profileViews: ViewrsActionLog[];
    graphicImpediment: GraphicImpediment[];
}

export interface GraphicImpediment {
    description: string;
    countSearch: number;
}

export interface ViewrsActionLog {
    name: string;
    viewrs: number;
    title: string;
}

export interface UserActionLog {
    dateEntered: Date;
    description: string;
    filtersDescription: string;
    searchText: string;
    actionDone: string;
    contactAction: string;
}