import {Pipe,PipeTransform} from '@angular/core';
import moment from 'moment';
import { Events } from '../models/events';
import { stat } from 'fs';

@Pipe({
    name:'filtroAuditEvent'
})

export class PaginationAuditPipe implements PipeTransform {
    transform(eventsAlt: Events[],page:number = 0, statusFilter: number = null, dateFilter: number = null): Events[]{
        let tableFilter : Events [] = eventsAlt;

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

            tableFilter = tableFilter?.filter(evt => (evt != null && evt.startDate != null && moment(evt.startDate).isSameOrAfter(dateCompare)));
        }

        if (statusFilter != null) {
            tableFilter = tableFilter?.filter(evt => (evt != null && evt.state != null && evt.state.id == statusFilter));
        }


        return tableFilter?.slice(page,page+5);
    }
}