import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { SearchItem, TypeImpairment } from 'src/app/interfaces';
import { SearchService, TypeImpairmentService } from 'src/app/services';
import { ConfigService } from 'src/app/services';
import moment from 'moment';

@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.scss']
})
export class SearchComponent implements OnInit {
  showMoreInfo = false; 
  typeImpairments: TypeImpairment[] = [];
  typeImpairmentsAux: boolean[] = [];
  resultsSearch: SearchItem[] = [];
  searchText: string = '';
  notResoult: boolean = false;
  events:boolean = true;
  posts:boolean = true;

  constructor( 
    private router: Router,
    private configService: ConfigService,
    private typeImpairmentService: TypeImpairmentService,
    private searchService: SearchService) { 
  }

  ngOnInit(): void {
  
    this.typeImpairmentService.getAlll().subscribe(resp => {
      for(let i = 0; i < resp.length; i++) {
        this.typeImpairmentsAux.splice(0,0,false)
      }
      this.typeImpairments = resp;
    });
  }

  public prepareDate(date: Date): string {
    if (date != null) {
      let dateAux = moment(date);
      return dateAux.format('D') + " " + dateAux.format('MMMM');
    } else {
      return '';
    }
  }

  public btn_search(): void {
    this.resultsSearch = [];
    this.notResoult = false;
    this.searchService.search(
      {
        searchText: this.searchText, 
        filters: (this.showMoreInfo ? this.getFilters() : null),
        events:this.events,posts:this.posts
      }).subscribe(resp => {
      this.resultsSearch = resp;
      if (resp.length == 0) {
        this.notResoult = true;
      }
    }, err => {
      this.notResoult = true;
    })
  }

  public getTitle(result: SearchItem): string {
    if (result != null) {
      if(result.key == 'PostId') {
        return result.title;
      } else {
        let aux = this.prepareDate(result.startDate);
        return aux  != '' ? aux + ' - ' + result.title : result.title;
      }
    } else {
      return '';
    }
  }

  public redirectToProfile(result: SearchItem): void {
    this.router.navigateByUrl(`/profile/${result.contactCreate.id}`)
  }

  public redirectToMoreInfo(result: SearchItem): void {
    if (result.key == 'PostId') {
      this.router.navigateByUrl(`/posts-info/${result.id}`)
    } else {
      this.router.navigateByUrl(`/events-info/${result.id}`)
    }
  }

  public getImage(result: SearchItem): string {
    if (result != null && result.imageUrl != null) {
      return result.imageUrl.trim()+'?c='+moment().unix();
    } else {
      return this.configService.dafaultImage();
    }
  }

  private getFilters(): TypeImpairment[] {
    let aux:TypeImpairment[] = [];
    for(let i = 0; i < this.typeImpairments.length; i++) {
      if (this.typeImpairmentsAux[i]) {
        aux.splice(0,0, this.typeImpairments[i]);
      }
    }
    
    return aux.length > 0 ? aux : null;
  }
}
