import { Component } from '@angular/core';
import { BlockUI, NgBlockUI } from 'ng-block-ui';
import { ConfigService } from './services';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  @BlockUI() blockUI: NgBlockUI;

  constructor(public configService: ConfigService) {
  }
}
