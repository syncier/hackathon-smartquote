import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';

@Component({
  selector: 'app-connect',
  templateUrl: './connect.component.html',
  styleUrls: ['./connect.component.scss']
})
export class ConnectComponent implements OnInit {

  inputValue: string = '';
  codeForm: FormGroup;

  constructor() { }
  
    ngOnInit() {
      this.codeForm = new FormGroup({
        keyCode: new FormControl(this.inputValue, {
          validators: [
            Validators.required,
            Validators.minLength(6)
          ],
          updateOn: 'blur'
        })
      });
    }
  
    get keyCode() {
      return this.codeForm.get('keyCode');
    }  

}
