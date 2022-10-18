Configuration FileDemo {
    Node localhost {
        File FileDemo {
            Type = 'Directory'
            DestinationPath = 'C:\TestUser3'
            Ensure = "Present"
        }
    }
}

FileDemo -OutputPath ./dsc/