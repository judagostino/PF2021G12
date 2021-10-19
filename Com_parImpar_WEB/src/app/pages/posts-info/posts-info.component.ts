import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Post } from 'src/app/models/post';
import { ConfigService, PostsService } from 'src/app/services';

@Component({
  selector: 'app-posts-info',
  templateUrl: './posts-info.component.html',
  styleUrls: ['./posts-info.component.scss']
})
export class PostsInfoComponent implements OnInit {
  post: Post;
  paragaphs: string[] = []; 

  constructor(
    private router: Router, 
    private activatedRoute: ActivatedRoute,
    private postsService: PostsService,
    private configService: ConfigService) { }

  ngOnInit(): void {
    this.activatedRoute.params.subscribe(params => {
      let id = params['id'];
      if (id != null && id != 0) {
        this.postsService.getByIdMoreInfo(id).subscribe(resp => {
          this.post = resp;
          this.paragaphs = [this.post.text.substr(0,100), this.post.text.substr(100,170), this.post.text.substr(170,300), this.post.text.substr(300,700), this.post.text.substr(700,1000)].concat( this.post.text.substr(1000,this.post.text.length).split('. A'))
        })
      }
    });
  }

  public getImage(): string {
    if (this.post != null && this.post.imageUrl != null) {
      return this.post.imageUrl.trim();
    } else {
      return this.configService.dafaultImage();
    }
  }

  public redirectToProfile(): void {
    this.router.navigateByUrl(`/profile/${this.post.contactCreate.id}`)
  }
}
