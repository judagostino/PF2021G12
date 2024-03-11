import { Component, OnInit } from '@angular/core';
import { EChartsOption } from 'echarts';
import { ActionsLog } from 'src/app/interfaces';
import { ActionsLogService } from 'src/app/services';

@Component({
  selector: 'app-action-log',
  templateUrl: './action-log.component.html',
  styleUrls: ['./action-log.component.scss']
})
export class ActionLogComponent implements OnInit {
  actionLog: ActionsLog = null;
  public chartOption: EChartsOption;
  public page:number = 0;
  public search:string = '';
  public actionFilter = null;
  public dateFilter = null;

  constructor(private actionsLogService: ActionsLogService) { }

  ngOnInit(): void {
    this.chartOption = null;
    this.actionsLogService.getAll().subscribe( (resp: ActionsLog) => {
      this.actionLog = resp;
      if (this.actionLog.graphicImpediment.length != null) {
        let dataColumns = [];
        let dataSeries: {name: string, value: number}[] = [];


        this.actionLog.graphicImpediment.forEach(element => {
          dataColumns.push(element.description);
          dataSeries.push({name: element.description, value: element.countSearch});
       });

        this.chartOption = {
          tooltip: {
            trigger: 'item',
            formatter: '{b} : Cantidad: {c} Porcentaje: {d}%',
          },
          legend: {
            orient: 'vertical',
            right: 0,
            data: dataColumns,
            top: 0,
          },
          series: [
            {
              data: dataSeries,
              type: 'pie',
              radius: '65%',
              right: '30%',
              center: ['50%', '50%'],
              animation: false,
              label: {
                show: false,
                formatter: '{c}%'
              },
            },
          ],
          grid: [{containLabel: true}]
        };
      } 
    });
  }

  public nextPage(){
    this.page += 5;
  }

  public prevPage(){
    if(this.page > 0)
    this.page -= 5;
  }

  public onSearch(search:string){
    this.page = 0;
    this.search = search;

  }
}
