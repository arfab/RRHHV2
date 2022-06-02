using System.ComponentModel.DataAnnotations;

namespace RRHH.Models
    {
    public class Usuario
    {
        public int id { get; set; }

        [Required(ErrorMessage = "El campo es requerido")]
        [Display(Name = "Usuario")]
        [StringLength(255, ErrorMessage = "{0} debe tener por lo menos {2} caracteres.", MinimumLength = 3)]
        public string UsuarioID { get; set; }

        [Required(ErrorMessage = "El campo es requerido")]
        [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$", ErrorMessage = "Al menos 8 caracteres, 1 mayúscula, 1 minúscula y 1 número.")]
        public string clave { get; set; }

        [Required(ErrorMessage = "El campo es requerido")]
        public string Apellido { get; set; }

        [Required(ErrorMessage = "El campo es requerido")]
        public string Nombre { get; set; }

        [Required(ErrorMessage = "El campo es requerido")]
        public int perfil_id { get; set; }

        public string? perfil_descripcion { get; set; }
    }
}


