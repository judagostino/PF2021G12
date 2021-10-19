import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { TypeImpairment } from 'src/app/intrergaces';
import { Post } from 'src/app/models/post';
import { PostsService, TypeImpairmentService, UploadService } from 'src/app/services';
import Swal  from 'sweetalert2';

@Component({
  selector: 'app-abm-posts',
  templateUrl: './abm-posts.component.html',
  styleUrls: ['./abm-posts.component.scss']
})
export class ABMPostsComponent implements OnInit {
  form: FormGroup;
  posts: Post[] = [];
  uploadForm: FormGroup;  
  imageAux = null;
  types: TypeImpairment[] = [];

  constructor(
    private formBuilder: FormBuilder, 
    private router: Router, 
    private postService: PostsService,
    private uploadService: UploadService,
    private typeImpairmentService: TypeImpairmentService) { }

  ngOnInit(): void {
    this.typeImpairmentService.getAlll().subscribe(response => {
      this.types = response;
    })
    this.initForm();  
    this.imageAux = null;
    this.form.reset(new Post());
    this.getGrid();
  }

  private initForm(): void {
    this.form = this.formBuilder.group({
      id: [null],
      dateEntered: [null],
      title: [null],
      description: [null],
      text: [null],
      state: [null],
      contactCreate: [null],
      contactAudit: [null],
      typeImpairment: [null]
    })
    this.uploadForm = this.formBuilder.group({
      file: ['']
    });
  }

  public onFileSelect(event) {
    if (event.target.files.length > 0) {
      const file = event.target.files[0];
      this.uploadForm.get('file').setValue(file);
    }
  }

  public btn_SavePost(): void {
    let newPost = this.form.value;
    console.log(newPost)
    if (newPost.id === 0) {
      this.insert(newPost);
    } else {
      this.update(newPost);
    }
  }

  public btn_NewPost(): void {
    this.form.reset(new Post());
    this.imageAux = null;
  } 

  public btn_DeletePost(): void {
    this.postService.delete(this.form.value.id).subscribe( () => {
      this.form.reset(new Post())
      this.imageAux = null;
    });
  }

  public btn_SelectPost(post: Post) : void {
    this.postService.getById(post.id).subscribe( resp => {
      this.form.reset(resp)  
      if (resp.imageUrl) {
        this.imageAux = resp.imageUrl
      }
    });
  }

  public btn_authorizePost() : void {
    this.postService.authorize(this.form.value.id).subscribe( () => {
    });
  }

  public btn_denyPost() : void {
    this.postService.deny(this.form.value.id).subscribe( () => {
    });
  }

  public objectComparisonFunction = function( option, value ) : boolean {
    return option.id === value.id;
  }
  
  private uploadImage(id: number) {
    if (this.uploadForm.get('file').value != null) {
      const formData = new FormData();
      formData.append('File', this.uploadForm.get('file').value);
      formData.append('Type', 'posts');
      formData.append('Id', id.toString());
  
      this.uploadService.upload(formData).subscribe((resp: string) => {
        console.log(resp)
        //this.imageAux = resp.trim();
      });
    }
  }

  private getGrid(): void {
    this.postService.getAll().subscribe( resp => {
      this.posts = [];
      this.posts = resp;
    });
  }

  private insert(post: Post): void {
    this.postService.insert(post).subscribe(resp => {
      this.form.reset(resp)
      this.uploadImage(resp.id);
      this.getGrid();
      Swal.fire(
        'Guardado',
        'Publicación guardado con exito!',
        'success'
      )
    });
  }

  private update(post: Post): void {
    this.postService.update(post.id,post).subscribe(resp => {
      this.form.reset(resp)
      this.uploadImage(resp.id);
      this.getGrid();
      Swal.fire(
        'Guardado',
        'Publicación guardado con exito!',
        'success'
      )
    });
  }
}
