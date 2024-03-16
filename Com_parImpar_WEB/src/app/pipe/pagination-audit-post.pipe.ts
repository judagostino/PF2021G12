import {Pipe,PipeTransform} from '@angular/core';
import moment from 'moment';
import { Post } from '../models/post';

@Pipe({
    name:'filtroAuditPost'
})

export class PaginationAuditPostPipe implements PipeTransform {
    transform(postsAlt: Post[],page:number = 0, statusFilter: number = null, dateFilter: number = null): Post[]{
        let tableFilter : Post [] = postsAlt;

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

            tableFilter = tableFilter?.filter(pst => (pst != null &&  pst.dateEntered != null && moment(pst.dateEntered).isSameOrAfter(dateCompare)));
        }

        if (statusFilter != null) {
            
            tableFilter = tableFilter?.filter(pst => (pst != null && pst.state != null && pst.state.id == statusFilter));
        }


        return tableFilter?.slice(page,page+5);
    }
}