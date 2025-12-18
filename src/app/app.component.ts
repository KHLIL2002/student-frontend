import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Department } from './department.model';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, HttpClientModule, FormsModule],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  // L'URL de ton Backend (via le tunnel)
// Change this line:
private apiUrl = 'http://192.168.21.129:30008/student/Depatment';  
  departments: Department[] = [];
  newDepartment: Department = { name: '', location: '', phone: '', head: '' };

  constructor(private http: HttpClient) {}

  ngOnInit() {
    this.getAllDepartments();
  }

  // Récupérer la liste
  getAllDepartments() {
    this.http.get<Department[]>(`${this.apiUrl}/getAllDepartment`)
      .subscribe(data => {
        this.departments = data;
      }, error => {
        console.error('Erreur API:', error);
      });
  }

  // Ajouter un département
  addDepartment() {
    this.http.post<Department>(`${this.apiUrl}/createDepartment`, this.newDepartment)
      .subscribe(() => {
        this.getAllDepartments(); // Rafraîchir la liste
        this.newDepartment = { name: '', location: '', phone: '', head: '' }; // Reset form
      });
  }
}