namespace RRHH.Models
{
    public class Empresa
    {
        public Empresa()
        {
        }

        public Empresa(int e_id, string e_descripcion,  string e_nomenclatura)
        {
            id = e_id;
            descripcion = e_descripcion;
            nomenclatura = e_nomenclatura;
        }
        public int id { get; set; }

        public string descripcion { get; set; }

        public string nomenclatura { get; set; }
    }
}
