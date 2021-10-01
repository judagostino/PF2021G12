import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ContactService } from 'src/app/services';

@Component({
  selector: 'app-recover-passord',
  templateUrl: './recover-passord.component.html',
  styleUrls: ['./recover-passord.component.scss']
})
export class RecoverPassordComponent implements OnInit {
  form: FormGroup
  constructor(private formBuilder: FormBuilder,private contactService: ContactService) {  }

  ngOnInit(): void {
    this.form = this.formBuilder.group({
      email: '',
      confirmEmail: '',
    })
  }

  public btn_recover():void{
    const recover = this.form.value;
    this.contactService.recoverPassword(recover).subscribe( () => {

    });
  }
}
