import { Component, OnInit } from '@angular/core';
import { Events } from 'src/app/models/events';
import { EventsService } from 'src/app/services';
import * as moment from 'moment';


// export interface PeriodicElement {
//   name: string;
//   position: number;
//   weight: number;
//   symbol: string;
// } 

@Component({
  selector: 'app-calendar',
  templateUrl: './calendar.component.html',
  styleUrls: ['./calendar.component.scss']
})


export class CalendarComponent implements OnInit {
  events: Events[] = [];
  calendarDates: number[] = [];
  month: String="";
  now = new Date();

  constructor(private eventsService: EventsService) { }

  ngOnInit(): void {
    this.createCalendar(this.now);
    this.initData(this.now);
    this.month = moment(this.now).format('MMMM');
  }

  public getEventsOfDay(day: number): number {
    if (day != 0) {
      return this.events.filter( event => (
        event.startDate != null 
        && moment(event.startDate).get('D') == day)
        ).length;
    }
    return 0;
  }

  private initData(date: Date): void {
    this.events = [];
    this.eventsService.getByDate(date).subscribe(response => {
      this.events = response;
    });

    //this.events= (JSON.parse('[{"id":1,"dateEntered":"2021-08-24T20:08:34","startDate":"2021-08-24T22:37:29","endDate":"2021-08-24T22:37:29","title":"este es una prueba","description":"este es una prueba","contactCreate":{"id":4,"name":"Vottero, Gaston"}},{"id":2,"dateEntered":"2021-08-24T21:31:09","startDate":"2021-08-24T00:00:00","endDate":"2021-08-24T00:00:00","title":"este es una prueba","description":"este es una prueba","contactCreate":{"id":1,"name":"Vottero, Gaston3"}},{"id":5,"dateEntered":"2021-08-24T21:31:14","startDate":"2021-08-24T00:00:00","endDate":"2021-08-24T00:00:00","title":"este es una prueba","description":"este es una prueba","contactCreate":{"id":2,"name":"Vottero, Gaston"}}]') as Events[]) 
  }

  private createCalendar(date: Date): void {
    let limit = moment(date).daysInMonth();
    this.calendarDates = [];
    let initMounth = moment(date.getFullYear() + '-' +( date.getMonth() + 1) + '-1')
    let fistItems = 0;

    switch(initMounth.isoWeekday()) {
      // Lunes
      case 1: {
        fistItems = 0;
        break;
      }
      case 2: {
        fistItems = 1;
        break;
      }
      case 3: {
        fistItems = 2;
        break;
      }
      case 4: {
        fistItems = 3;
        break;
      }
      case 5: {
        fistItems = 4;
        break;
      }
      case 6: {
        fistItems = 5;
        break;
      }
      //Domingo
      default: {
        fistItems = 6;
        break;
      }
    }

    if (fistItems > 0) {
      for(let i = 1; i <= fistItems; i++) {
        this.calendarDates.push(0)
      }  
    }

    for(let i = 1; i <= limit; i++) {
      this.calendarDates.push(i)
    }
  }

  public btn_Subtract() : void {
    let aux = moment(this.now).subtract(1,'M');
    this.month = aux.format('MMMM');
    this.now = aux.toDate();
    this.createCalendar(this.now);
    this.initData(this.now);
  }

  public btn_Add() : void {
    let aux = moment(this.now).add(1,'M');
    this.month = aux.format('MMMM');
    this.now = aux.toDate();
    this.createCalendar(this.now);
    this.initData(this.now);
  }
}

//TABLA MATERIAL NO FUNCIONA
//TS
// export class TableRowBindingExample {
//   displayedColumns: string[] = ['position', 'name', 'weight', 'symbol'];
//   dataSource = ELEMENT_DATA;
//   clickedRows = new Set<PeriodicElement>();
// }
// const ELEMENT_DATA: PeriodicElement[] = [
//   {position: 1, name: 'Hydrogen', weight: 1.0079, symbol: 'H'},
//   {position: 2, name: 'Helium', weight: 4.0026, symbol: 'He'},
//   {position: 3, name: 'Lithium', weight: 6.941, symbol: 'Li'},
//   {position: 4, name: 'Beryllium', weight: 9.0122, symbol: 'Be'},
//   {position: 5, name: 'Boron', weight: 10.811, symbol: 'B'},
//   {position: 6, name: 'Carbon', weight: 12.0107, symbol: 'C'},
//   {position: 7, name: 'Nitrogen', weight: 14.0067, symbol: 'N'},
//   {position: 8, name: 'Oxygen', weight: 15.9994, symbol: 'O'},
//   {position: 9, name: 'Fluorine', weight: 18.9984, symbol: 'F'},
//   {position: 10, name: 'Neon', weight: 20.1797, symbol: 'Ne'},
// ];

//HTML
// <div class="mat-elevation-z8">
//                                     <table mat-table [dataSource]="dataSource">
                                  
//                                       <!-- Position Column -->
//                                       <ng-container matColumnDef="position">
//                                         <th mat-header-cell *matHeaderCellDef> No. </th>
//                                         <td mat-cell *matCellDef="let element"> {{element.position}} </td>
//                                       </ng-container>
                                  
//                                       <!-- Name Column -->
//                                       <ng-container matColumnDef="name">
//                                         <th mat-header-cell *matHeaderCellDef> Name </th>
//                                         <td mat-cell *matCellDef="let element"> {{element.name}} </td>
//                                       </ng-container>
                                  
//                                       <!-- Weight Column -->
//                                       <ng-container matColumnDef="weight">
//                                         <th mat-header-cell *matHeaderCellDef> Weight </th>
//                                         <td mat-cell *matCellDef="let element"> {{element.weight}} </td>
//                                       </ng-container>
                                  
//                                       <!-- Symbol Column -->
//                                       <ng-container matColumnDef="symbol">
//                                         <th mat-header-cell *matHeaderCellDef> Symbol </th>
//                                         <td mat-cell *matCellDef="let element"> {{element.symbol}} </td>
//                                       </ng-container>
                                  
//                                       <tr mat-header-row *matHeaderRowDef="displayedColumns"></tr>
//                                       <tr mat-row *matRowDef="let row; columns: displayedColumns;"></tr>
//                                     </table>
                                  
//                                     <mat-paginator [pageSizeOptions]="[5, 10, 20]"
//                                                    showFirstLastButtons 
//                                                    aria-label="Select page of periodic elements">
//                                     </mat-paginator>
//                                   </div>