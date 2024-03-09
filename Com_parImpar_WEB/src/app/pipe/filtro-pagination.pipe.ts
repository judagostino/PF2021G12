import {Pipe,PipeTransform} from '@angular/core';
import {ActionsLog, UserActionLog} from '../interfaces/actions-log';

@Pipe({
    name:'filtro'
})

export class FiltroPagination implements PipeTransform {
    transform(actionLog: UserActionLog[],page:number = 0,search:string=''): UserActionLog[]{
        if(search.length == 0){
            return actionLog?.slice(page,page+10);
        }
        else {
            const filteredAction = actionLog.filter(
                action => 
                    action.contactAction?.toLowerCase().includes(search?.toLowerCase()) //devuelve la accion

            );
            return filteredAction?.slice(page,page+10);
        }
        
        
    }
}