import {Pipe,PipeTransform} from '@angular/core';
import {UserActionLog} from '../interfaces/actions-log';
import moment from 'moment';

@Pipe({
    name:'filtro'
})

export class FiltroPagination implements PipeTransform {
    transform(userActionLog: UserActionLog[],page:number = 0,search:string='', actionFilter: string = null, dateFilter: number = null): UserActionLog[]{
        let tableFilter = userActionLog;

        if (dateFilter != null) {
            let dateCompare;
            switch(dateFilter) {
                case 1: { // ultima semana
                    dateCompare = moment(new Date()).add(-1, 'week');
                    break
                }
                case 2: { // ultima mes
                    dateCompare = moment(new Date()).add(-1, 'month');
                    break
                }
                default: { // ultimo año
                    dateCompare = moment(new Date()).add(-1, 'year');
                    break
                }
            }

            tableFilter = tableFilter?.filter(userAction => (userAction != null && userAction.dateEntered != null && moment(userAction.dateEntered).isSameOrAfter(dateCompare)));
        }

        if (actionFilter != null) {
            tableFilter = tableFilter?.filter(userAction => (userAction != null && userAction.description == actionFilter));
        }


        if (search.length > 0) {
            const searchLowerCase = search.toLowerCase();
            tableFilter = tableFilter?.filter(userAction => {
              const fieldsToSearch = [
                userAction.actionDone?.toLowerCase(),
                userAction.searchText?.toLowerCase(),
                userAction.filtersDescription?.toLowerCase()
              ];
      
              return fieldsToSearch.some(field => field?.includes(searchLowerCase));
            });
        }

        return tableFilter?.slice(page,page+10);
    }
}