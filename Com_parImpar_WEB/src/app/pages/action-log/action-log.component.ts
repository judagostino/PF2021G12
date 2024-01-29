import { Component, OnInit } from '@angular/core';
import { ActionsLog } from 'src/app/intrergaces';
import { ActionsLogService } from 'src/app/services';

@Component({
  selector: 'app-action-log',
  templateUrl: './action-log.component.html',
  styleUrls: ['./action-log.component.scss']
})
export class ActionLogComponent implements OnInit {
  actionLog: ActionsLog = null;
  type = 'PieChart';
  data = [];
  columnNames = ['Tipo de discapacidad', 'cantidad'];

  constructor(private actionsLogService: ActionsLogService) { }

  ngOnInit(): void {
     this.data = [];
    this.actionsLogService.getAll().subscribe( (resp: ActionsLog) => {
      this.actionLog = resp;
      if (this.actionLog.graphicImpediment.length != null) {
        this.actionLog.graphicImpediment.forEach(element => {
          this.data.push([element.description, element.countSearch])
       });
      
      } 
    }); 
  

  
  
  
  
  
  }
}
